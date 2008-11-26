Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbYKZLaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbYKZLaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 06:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbYKZLaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 06:30:22 -0500
Received: from mail-qy0-f22.google.com ([209.85.221.22]:58191 "EHLO
	mail-qy0-f22.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbYKZLaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 06:30:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Gk78c4KAbOQO3boXl7QUpljUh7QV743sl3q8w0TlGyqaDNEdU2EQN6W77FPmTxZEa2
         VG7gcjknXNrSlYY5Luri8wYt0vWASdc4mxmhmtwZ9dn5FNV2I5WTIakkCp9KEuh69Hpy
         hV8afN7pL32XSVVUSKDQZd7N1PRKkKcL6g8Kk=
Message-ID: <c62985530811260311q9dc98bfxbdb1cef1c7007d2a@mail.gmail.com>
Date: Wed, 26 Nov 2008 12:11:59 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing/function-return-tracer: set a more human readable output
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081126021243.GA17567@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492C90E5.8070907@gmail.com> <20081126003936.GA26937@elte.hu>
	 <20081126021243.GA17567@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/26 Ingo Molnar <mingo@elte.hu>:
>
> there's a small inconsistency here:
>
> # cat available_tracers
> function-graph function sched_switch nop
>
> note the '-' versus '_' separators. I wouldnt mind renaming the sched
> tracer to sched-switch. (and some of the other tracers as well)
>
>        Ingo
>

Will correct it too.
