Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbYKMJlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbYKMJlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 04:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbYKMJk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 04:40:56 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:58549 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYKMJkz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 04:40:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kq37INGSwU1gNMyUN/jnyDe0NRaw12FtlcCVJ/PTWMoSNurlI0lQMWPQYqsHaGRbcq
         VClnG10wa7AaVy6GVp7h6p1FPTLg6lnHSXJspH77iLsL+mDWji8e9r+4CO23TsgnvCs3
         PR9wmmw4ik6jXNiZvXY6c+lOnSJiWBOAlTarY=
Message-ID: <c62985530811130140r664052bdrd76772c7ea10646b@mail.gmail.com>
Date: Thu, 13 Nov 2008 10:40:54 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 2/2] tracing/function-return-tracer: Call prepare_ftrace_return by registers
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <c62985530811130138v69b260dcy59adfba24afee0ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <491B4F63.3090909@gmail.com> <20081112221623.GB6125@elte.hu>
	 <c62985530811121422w6d33de3cp506bdf1aa96efd81@mail.gmail.com>
	 <alpine.DEB.1.10.0811121824380.21116@gandalf.stny.rr.com>
	 <c62985530811121535t13a60c93y9e4c22e365ca1b34@mail.gmail.com>
	 <alpine.DEB.1.10.0811121911340.30248@gandalf.stny.rr.com>
	 <20081113085949.GG25479@elte.hu>
	 <c62985530811130138v69b260dcy59adfba24afee0ca@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/13 Frédéric Weisbecker <fweisbec@gmail.com>:
> So perhaps naming it by thinking on the purpose it could be use at
> most would be better that its "general" or "potential"
> purpose. I don't know...

Oops. s/that/than
