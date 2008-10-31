Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbYJaBfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbYJaBfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 21:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbYJaBf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 21:35:28 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:9178 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbYJaBf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 21:35:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QhX/fg9vUZnhytsmT4xwSMB4OMCK4a+QWeKtb7f8bKFw7FcRVh5UpbAArgCjsLgvoN
         GyzuqriNF4StvgmeyXVhH5nbRstSoknCLaFgeNoSmXlX2HoYcHjhedHXoLMB0N2s9NpZ
         SV/X/68Nqp9iOfHwbwlxijYj+bu5nv0mUK8ko=
Message-ID: <c62985530810301835p254fc235jbd5843c2cee287c2@mail.gmail.com>
Date: Fri, 31 Oct 2008 02:35:26 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [RFC][PATCH] Make ftrace able to trace function return
Cc: "Steven Rostedt" <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20081030183714.GA17822@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <490A08E3.2040201@gmail.com> <20081030182056.GA14102@elte.hu>
	 <c62985530810301130q41cc5c0ete2d7610d2172775@mail.gmail.com>
	 <20081030183714.GA17822@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/30 Ingo Molnar <mingo@elte.hu>:
> if it can be made stable ;-)


I hope so... The real problem is that when the system freezes as I allocate
more than on slot, I don't have any log message, no backtraces..... :-s
