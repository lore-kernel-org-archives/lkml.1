Return-Path: <linux-kernel-owner+w=401wt.eu-S1758586AbXKQPtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586AbXKQPtz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 10:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbXKQPtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 10:49:47 -0500
Received: from smtp109.plus.mail.re1.yahoo.com ([69.147.102.72]:38435 "HELO
	smtp109.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750995AbXKQPtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 10:49:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=uNEMHzMySnMwUmPz328EBWQRs5PqkFZ4xD0Pl4JmNLQbtpYqTYDBXKXUpqcB3vAf0xeS9Q3rz1MYIw7gXZaIJgL4FD0lDJ1Je4kpe93cCVe5Pg/7fv9wMT3DfyD9FznrFtzaRXBJheDSEumaGWQ2I0bzfLYx74ad1PZGuSEmcC8=  ;
X-YMail-OSG: GkdKg84VM1muRIY33fUS5nN26.629lHe4PKIbTLqq3jHjLapTpSN7DMQI83vIjJFetXoNfdkKQ--
Date: Sat, 17 Nov 2007 13:50:07 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [rfc-patch 0/9] Immediate Values for 2.6.24-rc2-git5
Message-ID: <20071117125007.GA4450@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20071116200238.740495156@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071116200238.740495156@polymtl.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 03:02:38PM -0500, Mathieu Desnoyers wrote:
Hi, 
just a conventions proposal: have you thought of shortening all those
"immediate_foo" prefixes to 'imm_foo', for example? This'll make the 
code much more readable, i think.

- 
Regards/Gruﬂ,
    Boris.
