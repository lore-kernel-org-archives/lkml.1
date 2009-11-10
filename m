Return-Path: <linux-kernel-owner+w=401wt.eu-S1758632AbZKJWyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632AbZKJWyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758608AbZKJWyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:54:43 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:44641 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758541AbZKJWyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:54:36 -0500
Date: Tue, 10 Nov 2009 22:54:41 +0000
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, Willy Tarreau <w@1wt.eu>,
       Pavel Machek <pavel@ucw.cz>, Avi Kivity <avi@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091110225441.GQ15157@caffeine.csclub.uwaterloo.ca>
References: <4AF9C3EF.6000705@redhat.com> <4AF9C6AB.8080006@zytor.com> <20091110201602.GA26633@1wt.eu> <20091110205445.GB1407@ucw.cz> <20091110211259.GD26633@1wt.eu> <4AF9D8E2.7050205@zytor.com> <20091110222756.GF15159@caffeine.csclub.uwaterloo.ca> <4AF9E94D.5040601@zytor.com> <20091110223407.GN15157@caffeine.csclub.uwaterloo.ca> <4AF9EB4A.1050601@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF9EB4A.1050601@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 02:38:02PM -0800, H. Peter Anvin wrote:
> Also, the x87 FPU is a very clunky beast that's slow to emulate (unlike
> SSE).

Yeah x87 is rather horrible.

-- 
Len Sorensen
