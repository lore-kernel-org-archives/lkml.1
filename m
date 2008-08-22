Return-Path: <linux-kernel-owner+w=401wt.eu-S1756342AbYHVTk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbYHVTk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 15:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYHVTkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 15:40:13 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:46947 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbYHVTkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 15:40:12 -0400
Date: Fri, 22 Aug 2008 16:40:23 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080822164023.7060137e@doriath.conectiva>
In-Reply-To: <48AF014D.8040103@zytor.com>
References: <20080820162925.75a5e064@doriath.conectiva>
	<48ADDF4F.2020401@zytor.com>
	<48AE5FCF.6030103@zytor.com>
	<20080822065012.GV14110@elte.hu>
	<20080822113941.147a1db0@doriath.conectiva>
	<20080822153451.GA8390@Krystal>
	<20080822132948.57e47076@doriath.conectiva>
	<20080822163520.GA9860@Krystal>
	<20080822142054.403cbdef@doriath.conectiva>
	<48AF014D.8040103@zytor.com>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.7; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 22 Aug 2008 11:11:25 -0700
"H. Peter Anvin" <hpa@zytor.com> escreveu:

| Hi Luiz, two more tests:
| 
| 1. a small program to run in userspace and tell us what you get;

 88776655:44332211

 It is the same output in the virtualized system and the host
system.

| 2. a patch against -linus for testing.

 I have tried this patch with Linus tree early today, should I try
it with Ingo's tree too?

-- 
Luiz Fernando N. Capitulino
