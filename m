Return-Path: <linux-kernel-owner+w=401wt.eu-S1759348AbYD0LOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348AbYD0LOi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 07:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbYD0LO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 07:14:27 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:42097 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbYD0LO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 07:14:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=HchGpc+uLVeIKK3GldycVRE6lMyX8ebz22rJ0YqTF1PsG8usCqhCFZIMRtHlK1EGLCB5Idfazu3Ga3Uu/vz95ql+5GDJYUF5wQChjLuHl0NxqwqPNeGI/z6OftN5Q2MuckgRGDxTSMJSA8acn+APplkSIWYCO6hVAz8b5YVAufE=
Message-ID: <2f11576a0804270414t3ef16998me2ff2afd21eedbe7@mail.gmail.com>
Date: Sun, 27 Apr 2008 20:14:26 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] ftrace, v15
Cc: linux-kernel@vger.kernel.org, "Steven Rostedt" <rostedt@goodmis.org>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
In-Reply-To: <20080427063019.GA23295@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080427063019.GA23295@elte.hu>
X-Google-Sender-Auth: cc4c1c9a50ee8dd0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

>  the current/latest ftrace tree can be pulled from:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git
>
>  the full diffs are too large to be included here, but the shortlog and
>  the diffstat is below. Not much changed in the fundamentals since the
>  last lkml posting - but many small details were refined.

I hope ftrace people discussio LTTng people more.
AFAIK nobody explain pros. and cons. ftrace against marker approach.
(of cource, LTTng people doen't explain it too)

I believe tracing feature is very important.
too few discussion is sad ;-)

Why nobody try to integrate ftrace and LTTng?
and, Why don't you separate sched-devel tree and ftrace-devel tree?
