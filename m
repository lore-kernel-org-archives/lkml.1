Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbYJUOh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbYJUOh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 10:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbYJUOhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 10:37:12 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:58305 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbYJUOhL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 10:37:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=aU7ckBxCnjUUyYlW9ujO49W3hKvM7RdvcpyZiGjfzbhr/RTIhHB4qaH9DpAPpxDQqf
         9EKrnEpEOZyA+/dnfUQ/U6wFHqNI9m4Z7ZP8hrOQQyMJch1OpP/iNZp1sEo5aSTgmvMP
         2pWmOy8csEVUgTlghXK53IH+3cQCoBeOyA7Tg=
Message-ID: <c62985530810210737i6a5685beo49481848793719a3@mail.gmail.com>
Date: Tue, 21 Oct 2008 16:37:09 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH] trace: create tracers menu
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <c62985530810210734l2d6a7647tf0d38e74f1a60981@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1224599478.22771.45.camel@twins>
	 <c62985530810210734l2d6a7647tf0d38e74f1a60981@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/21 Frédéric Weisbecker <fweisbec@gmail.com>:
> 2008/10/21 Peter Zijlstra <peterz@infradead.org>:
>> Subject: trace: create tracers menu
>> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Date: Tue Oct 21 16:26:36 CEST 2008
>>
>> We seem to have plenty tracers, lets create a menu and not clutter
>> the already cluttered debug menu more.

But...you just included the function tracer inside?
