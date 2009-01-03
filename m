Return-Path: <linux-kernel-owner+w=401wt.eu-S932663AbZACDuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbZACDuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 22:50:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932330AbZACDt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 22:49:58 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:50219 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347AbZACDt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 22:49:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=aT5koQP3xszPZ4OJVgXwm+Ts1QkgPR44XDewp6qkJrFvY7MAKkO7QX/sQFuVXb7MbD
         rUqjmcf47a+PytKRU3dRJFJ65dYf1mF6MU28jVo4EHsKfDr2K78eALTfkmSI9IYNQd31
         rmDJEGHb5JeMUtSKf9JSzwvtT23I+sb5O1u88=
Message-ID: <3ae3aa420901021949m1df64dadh693ad39618476524@mail.gmail.com>
Date: Fri, 2 Jan 2009 21:49:53 -0600
From: "Linas Vepstas" <linasvepstas@gmail.com>
Reply-To: linasvepstas@gmail.com
To: linux-kernel@vger.kernel.org
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Cc: "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       "Travis Crump" <pretzalz@techhouse.org>,
       Goodgerster <goodgerster@gmail.com>, burdell@iruntheinter.net
In-Reply-To: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/2 Linas Vepstas <linasvepstas@gmail.com>:
> Slashdot reported a story of Linux machines crashing on New years eve.

FYI, Looks like the bug has been found, and theres a patch!

http://lkml.org/lkml/2009/1/2/389

--linas
