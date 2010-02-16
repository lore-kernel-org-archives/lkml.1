Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649Ab0BPO4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 09:56:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57140 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932525Ab0BPO4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 09:56:05 -0500
X-Authority-Analysis: v=1.0 c=1 a=uTOmaDeAZlAA:10 a=7U3hwN5JcxgA:10 a=dfLKRL6rylR_DE9mRgUA:9 a=0Niu_9IsJGdlFSABlNKeMWfuW4QA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [kernel.org users] XZ Migration discussion
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jean Delvare <khali@linux-fr.org>, mirrors@kernel.org,
       lasse.collin@tukaani.org, linux-kernel <linux-kernel@vger.kernel.org>,
       users@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <10f740e81002131049o196380a6tf863b7713e5aafc5@mail.gmail.com>
References: <4B744E13.8040004@kernel.org>
	 <20100211205129.GA26105@elf.ucw.cz>
	 <20100213181008.479509f5@hyperion.delvare>
	 <10f740e81002131049o196380a6tf863b7713e5aafc5@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 16 Feb 2010 09:55:57 -0500
Message-ID: <1266332158.24271.125.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-13 at 19:49 +0100, Geert Uytterhoeven wrote:

> BTW, who still downloads full kernel tarballs? From my experience, that's mostly
> distro people who have scripts to build kernels from tarballs + a
> bunch of patches?

When I download to develop, I use git. When I just want to install the
latest kernel on a box (not used for development) I use ketchup
(downloads tarballs).

For those that just want the latest kernel release, git is too bloated.

-- Steve


