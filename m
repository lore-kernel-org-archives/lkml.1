Return-Path: <linux-kernel-owner+w=401wt.eu-S1760220AbYDLBEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220AbYDLBEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 21:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbYDLBEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 21:04:09 -0400
Received: from web52503.mail.re2.yahoo.com ([206.190.48.186]:20229 "HELO
	web52503.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755690AbYDLBEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 21:04:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=z6KpkmaJR8tJCXOYiXi+HTYAs5TaLgBBswp4tNHikhj0dYCQlEWvI2HacaSq53aQcqf3+w0BG9IVsH+9ae67zULhzRBNQyaawOG2QJfchfARlElxRtCP2q3hY/MRUlEZogW7Xb16pBMjvqLz8vKRPJfO9UGtTJoIIhrCB/cgKdU=;
X-YMail-OSG: idfehj0VM1l8C1xDAomC4HfzsT23yoX0gsyuKrIfau7uZEFnXnWkat1mrTJD_dt0xPrBqWniRT5lTDtuU8QYs_3smt30DlCiaW9ByhxWSYXIrQ8UwV8Y0jBucWAx
Date: Fri, 11 Apr 2008 18:04:06 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: AMD Quad Core clock problem?
To: Chris Snook <csnook@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47FFD3F3.50107@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <303918.65020.qm@web52503.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My best guess at this time is that the drift of this
computer using the quad core is so great that the ntpd
can't get in sync. Is there any way to make ntpd more
agressive by setting something in ntp.conf?


Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
