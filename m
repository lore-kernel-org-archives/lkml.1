Return-Path: <linux-kernel-owner+w=401wt.eu-S1751182AbZLUXSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751182AbZLUXSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 18:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbZLUXSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 18:18:45 -0500
Received: from wolff.to ([65.117.131.163]:48596 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750988AbZLUXSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 18:18:45 -0500
Date: Mon, 21 Dec 2009 17:16:45 -0600
From: Bruno Wolff III <bruno@wolff.to>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       phillip.lougher@gmail.com, tim.bird@am.sony.com
Subject: Re: [PATCH 0/9] Squashfs: Add support for LZMA compressed filesystems
Message-ID: <20091221231645.GA32141@wolff.to>
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

Do these still have a chance to make 2.6.33?
