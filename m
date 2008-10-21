Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbYJUOsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbYJUOsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 10:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbYJUOru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 10:47:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:64346 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbYJUOrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 10:47:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wWj/nQ22wXxeLrfiMtUCvKwY9LaTdyP28rSOufkuAiCCQyv+21x5Rm8U2pZMJxqC9n
         roGPMWuj0uws6SWVPjsqhc/HQaNtm3fKmADGcnK2Du109ljk5iayejqNVrX2bhUae4P5
         RAtDfOtBdO9NZndgQq9qwFfsssEX3wdn0P7jQ=
Message-ID: <c62985530810210747v14ffcb0q91e2d3459128b97e@mail.gmail.com>
Date: Tue, 21 Oct 2008 16:47:48 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH] trace: create tracers menu
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <1224600082.22771.56.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1224599478.22771.45.camel@twins>
	 <c62985530810210734l2d6a7647tf0d38e74f1a60981@mail.gmail.com>
	 <c62985530810210737i6a5685beo49481848793719a3@mail.gmail.com>
	 <1224600082.22771.56.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/21 Peter Zijlstra <peterz@infradead.org>:
> Problem being? That's a tracer too, right? And it doesn't seem required
> by the other tracers (except the max stack tracer).


Sorry I didn't want to write "just" but "only". I misread the patch
and I believed
there only was the function tracer inside.
