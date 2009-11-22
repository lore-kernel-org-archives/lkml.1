Return-Path: <linux-kernel-owner+w=401wt.eu-S1753714AbZKVWEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbZKVWEK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 17:04:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbZKVWEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 17:04:10 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:58401 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbZKVWEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 17:04:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nVyVhroaeGTwt9TsNj560p2oAlPgf4IBe/ovV5tWBUOjWMORmpkFoR/EstRzuGomvp
         ASAX42BT4j+Y/bRZli7VMC/h0evQYf+6ZjswUU/idEOScFJVaC7zd6GQ720u8awJifND
         QIlSTaYw1mi/BgNQhd5I4seMzSQemcqlUXNmM=
Date: Mon, 23 Nov 2009 08:56:27 +1100
From: Robert Swan <swan.r.l@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [bisected] pty performance problem
Message-ID: <20091122215627.GB4942@swanrl.gmail.com>
Reply-To: swan.r.l@gmail.com
References: <20091121222319.GA3905@swanrl.gmail.com> <20091122063926.GA18224@elte.hu> <20091121231514.3012e679@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091121231514.3012e679@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 21, 2009 at 11:15:14PM -0800, Arjan van de Ven wrote:
> On Sun, 22 Nov 2009 07:39:26 +0100
> Ingo Molnar <mingo@elte.hu> wrote:

> let me guess; you have HZ=250 and the other person has HZ=1000...
> since this seems consistent with doing a 1 jiffy delay...

Right, but you know, I have a strange feeling that wasn't a guess.

Rob.
