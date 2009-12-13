Return-Path: <linux-kernel-owner+w=401wt.eu-S1752990AbZLMBMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbZLMBMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750720AbZLMBMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:12:16 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:53265 "HELO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754880AbZLMBMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:12:09 -0500
Message-ID: <4B2432CA.1090800@pardus.org.tr>
Date: Sun, 13 Dec 2009 02:18:18 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Phillip Lougher <phillip@lougher.demon.co.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] Squashfs: Add support for LZMA compressed filesystems
References: <E1NHZ6K-00029J-Sw@dylan.lougher.demon.co.uk> <20091212052922.GB31742@wolff.to>
In-Reply-To: <20091212052922.GB31742@wolff.to>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bruno Wolff III wrote:
> On Mon, Dec 07, 2009 at 08:37:48 +0000,
>   Phillip Lougher <phillip@lougher.demon.co.uk> wrote:
>   
>> Hi,
>>
>> The following patches add LZMA decompression support to Squashfs, using the
>> in-kernel LZMA decompression library.
>>     
>
> I am a member of the Spins SIG and the Games Spin maintainer for Fedora.
> Thanks for working to get LZMA squashfs included in 2.6.33. If this
> gets accepted, we will have livecd-creator using it in F13 in order
> to include more packages in size limited images (such as the Games Spin)
> or reduce the size other images
>   

Similar, I was looking forward to squashfs-lzma to use it on our
distribution's installation/live medium. I once digged into the openwrt
patches and failed. Now I tested your patches (on top of 2.6.30.9) +
userspace from CVS patched with lzma 4.65, it's working flawlessly. With
lzma, our live cd image's size decreased from 820mb to 692mb.

Thanks a lot for your work
Ozan Caglayan

