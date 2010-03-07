Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab0CGOPM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 09:15:12 -0500
Received: from wolff.to ([65.117.131.163]:35421 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753237Ab0CGOPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 09:15:09 -0500
Date: Sun, 7 Mar 2010 08:14:44 -0600
From: Bruno Wolff III <bruno@wolff.to>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL V2] Squashfs updates for 2.6.34-rc1
Message-ID: <20100307141444.GA1812@wolff.to>
References: <4B91317D.7000205@lougher.demon.co.uk>
 <20100306205341.GA28316@wolff.to>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100306205341.GA28316@wolff.to>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 06, 2010 at 14:53:41 -0600,
  Bruno Wolff III <bruno@wolff.to> wrote:
> 
> I saw that Linus pulled this and some earlier related packages. I am not sure
> if I should expect working lzma squashfs in 2.6.34 right now, or if I still
> need to wait a bit?

I believe I correctly tested this and found that I indeed do have to wait
for more to happen for lzma support. But it didn't seem to cause a problem
for zlib support.
