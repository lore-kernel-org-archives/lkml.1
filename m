Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbZCVXxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbZCVXxs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 19:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbZCVXxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 19:53:34 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:44600 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757226AbZCVXxb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 19:53:31 -0400
Date: Sun, 22 Mar 2009 23:35:02 +0000
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Baybal Ni <nikulinpi@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: My new fancy font for framebuffer
Message-ID: <20090322233502.GC1114@deepthought>
References: <ff479ab60903210945p51c78f4fgf434d159e880de95@mail.gmail.com> <20090321111520.5fb73195@infradead.org> <49C5BBE8.6010906@zytor.com> <ff479ab60903220222w1d10da15xd446fb4eabfde4d1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <ff479ab60903220222w1d10da15xd446fb4eabfde4d1@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
X-Cloudmark-Analysis: v=1.0 c=1 a=puF0QrJjVYcQqkOTLSAA:9 a=6w4odNvU9xOERIbFtZ4A:7 a=rS0MNBASWLihun_yYwDOonhdP10A:4 a=LY0hPdMaydYA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 22, 2009 at 06:22:11PM +0900, Baybal Ni wrote:
> 
> Yes, but we want it to be bundled in kernel, for me it is the only
> option for systems with qvga screens or so on. Old fonts were nice
> only on CRT displays, but on TFTs they are giving too much load on
> eyes and brain. More clean contoured fonts are effectively cutting it.

 Who are the "we" who want it to be in the kernel ?

 There are _many_ available screen fonts, and I can understand
people being unhappy with the common existing fonts, particularly
once messages move beyond English into whatever locale you are using
(I use my own variant console font [1] to cover most European
languages with letter forms that I find easy to read), but what
specific problem does putting terminus in the kernel solve ?

 e.g. are the kernel's boot messages *before* you run 'setfont'
illegible ?  If so, what is your specific hardware ?

 I've been using only TFTs for a few years, and I don't see any
significant problems, only questions of preferred letter shapes and
glyph coverage.  But then, I'm a native English speaker, so I have
to be willing to accept that a font I find easy to read might not be
easy for people who do not normally use a latin alphabet.  If that
applies to you, you need to provide reasons why this belongs in the
kernel instead of userspace.

ken

[1] sigma-consolefonts - you probably won't like it ;-)
-- 
das eine Mal als Tragödie, das andere Mal als Farce
