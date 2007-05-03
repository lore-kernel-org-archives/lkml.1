Return-Path: <linux-kernel-owner+w=401wt.eu-S1162178AbXECQ5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162178AbXECQ5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 12:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162182AbXECQ5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 12:57:53 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:44186 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162178AbXECQ5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 12:57:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=HSUj06Q1pwdRBa4i4RdNjt4jCuWcWyPesPkbiFPXVylTTCF7/SAEt0hv3/5L5IH37ENjy101lOmnyz8nd7glRPjspyoXYQ7o13oNBbwmOxy9J9OeZxB4wHe8rY8ShPqtO00RdwAX7YqbRd3rT5K2JSS9aA1tCgdJxrlGWjN/7Tc=
Message-ID: <84144f020705030957j2cc8bfbds13797c0619e8f96c@mail.gmail.com>
Date: Thu, 3 May 2007 19:57:51 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "kernel coder" <lhrkernelcoder@gmail.com>
Subject: Re: bechmarking kernel code
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <f69849430705030402v5e737de4sc6ab246a1c64ec0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f69849430705030402v5e737de4sc6ab246a1c64ec0e@mail.gmail.com>
X-Google-Sender-Auth: dc0771579b8a8f0d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/3/07, kernel coder <lhrkernelcoder@gmail.com> wrote:
>      I'm profiling some part of kernel code.Mine profiling mechanism
> is based on rdtsc instruction.

Why dont you use oprofile?
