Return-Path: <linux-kernel-owner+w=401wt.eu-S1758293AbZLLFhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293AbZLLFhN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 00:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758131AbZLLFhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 00:37:12 -0500
Received: from wolff.to ([65.117.131.163]:59308 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758114AbZLLFhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 00:37:12 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Dec 2009 00:37:11 EST
Date: Fri, 11 Dec 2009 23:29:22 -0600
From: Bruno Wolff III <bruno@wolff.to>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] Squashfs: Add support for LZMA compressed filesystems
Message-ID: <20091212052922.GB31742@wolff.to>
References: <E1NHZ6K-00029J-Sw@dylan.lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1NHZ6K-00029J-Sw@dylan.lougher.demon.co.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 08:37:48 +0000,
  Phillip Lougher <phillip@lougher.demon.co.uk> wrote:
> Hi,
> 
> The following patches add LZMA decompression support to Squashfs, using the
> in-kernel LZMA decompression library.

I am a member of the Spins SIG and the Games Spin maintainer for Fedora.
Thanks for working to get LZMA squashfs included in 2.6.33. If this
gets accepted, we will have livecd-creator using it in F13 in order
to include more packages in size limited images (such as the Games Spin)
or reduce the size other images.
Possibly it will be mentioned as a "feature" for the F13 release. I have
a proposed feature page set up and waiting for these patches to be accepted at:
https://fedoraproject.org/wiki/Features/LZMA_for_Live_Images
