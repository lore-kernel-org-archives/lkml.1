Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbYJUMmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbYJUMmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 08:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbYJUMmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 08:42:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:14470 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbYJUMmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 08:42:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Hg5CVxWK7F67CFqWWZ9XuaLXs6EfDtSAQKB14sgy2g97OGOmqcn0RC6MAl9WHEVjt/
         +47VwzXC+fBxYpdd9sBQk/KEkwh1GZFeOC5z2hIKT2Bwy1HiE4heI4MFEo3F9M/ly2Zf
         Kl/5L/sGHlV4bxQSpVRmEoUtsdM3rEasxaauQ=
Message-ID: <c62985530810210542nb526081p9daac1027a72a269@mail.gmail.com>
Date: Tue, 21 Oct 2008 14:42:21 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 5/5] tracing/ftrace: Introduce the big kernel lock tracer
Cc: linux-kernel@vger.kernel.org, "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <20081021123234.GA30726@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48F10B0B.406@gmail.com>
	 <c62985530810210528t416c82b2lbe8471322e8359c@mail.gmail.com>
	 <20081021123234.GA30726@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/21 Ingo Molnar <mingo@elte.hu>:
> Correct, we froze down for the merge window. Thawing it now :)

Ok, it's an element of the process that I wasn't aware about :)

Thanks!
