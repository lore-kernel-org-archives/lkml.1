Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbYBZFPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbYBZFPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 00:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbYBZFPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 00:15:40 -0500
Received: from ozlabs.org ([203.10.76.45]:36297 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbYBZFPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 00:15:40 -0500
Date: Mon, 25 Feb 2008 23:13:07 -0600
From: Anton Blanchard <anton@samba.org>
To: Soeren Sandmann <sandmann@daimi.au.dk>
Cc: John Levon <levon@movementarian.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       tglx@tglx.de, hpa@zytor.com
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Message-ID: <20080226051307.GC17772@kryten>
References: <20080219123756.6261c13c@laptopd505.fenrus.org> <20080223001130.d8922136.akpm@linux-foundation.org> <20080223113724.GB31304@elte.hu> <20080223135335.GA28464@totally.trollied.org.uk> <ye8ejb3e8ef.fsf@camel10.daimi.au.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ye8ejb3e8ef.fsf@camel10.daimi.au.dk>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> It was only later I tried oprofile and found it not only much more
> difficult to use, but also much less useful when I did get it to work.

This surprises me. Can you please elaborate on why oprofile is "much
less useful" than sysprof?

Anton - who has used oprofile to analyse and tune databases, JVMs,
	compilers and operating systems. Maybe I've been missing out on
	the killer app for all this time!!!
