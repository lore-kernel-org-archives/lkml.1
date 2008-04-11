Return-Path: <linux-kernel-owner+w=401wt.eu-S1761461AbYDKS1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761461AbYDKS1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 14:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760447AbYDKS12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 14:27:28 -0400
Received: from web52505.mail.re2.yahoo.com ([206.190.48.188]:24850 "HELO
	web52505.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760162AbYDKS12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 14:27:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=yapUjqeAhf3GCBxstqHohSYPsXJoYTLuQaYxk9QvUGgFAzdjs5B2s91/HDg1vWE0XfisWtGA+PfMImt91FUYBxiIADDMxO+JSmSR41yqy5/bgSPFODVpUXl55J402I8mcKBBpDFpxLhryWiG8Ixe2njeW7QFwEPfGsX7/ZPZEck=;
X-YMail-OSG: to7ydRwVM1ltJ9Kgwge2cgAfJ1JESWc23nRqkq9UwC6WLkpIeus_hYx9_0xR8DzM__FzJxdjwQwy1rJlxRsQgfqd5we5sqmpNYHQeu3_BN1G0rL9CzrmkzhlKd.TUWBjQ.5c25attuJNsukNpjsMhxrmvw--
Date: Fri, 11 Apr 2008 11:27:26 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: AMD Quad Core clock problem?
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <632977.6298.qm@web52505.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was just wondering if there were any known issues
with AMD quad core phenom clock drift problems? I';m
running a 2.6.24 kernel and it's losing time. I
remember the first dual core AMD chips had a lot of
clock issues.

If this is something new let me know what information
to check and post to this list.


Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
