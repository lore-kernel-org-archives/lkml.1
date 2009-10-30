Return-Path: <linux-kernel-owner+w=401wt.eu-S932656AbZJ3RJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656AbZJ3RJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 13:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932106AbZJ3RJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 13:09:50 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:63274 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093AbZJ3RJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 13:09:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=cc0AWRSeRPk/M0iq1u0z6ilR028/mqh7hNyg0qSgePGU/XL8cS6ruyWz89D9q+kpaK
         eWEI+rUzYc1qK+tBRIf4NlRwQ1e/p5C/0b8QnxJN2vOotWJc1HsNlFQF4aVdW2JTocrG
         CJXVLbm9LpErYKcEV/pZeb1iRmMpqok1/kn2g=
MIME-Version: 1.0
In-Reply-To: <6217e0a0910300935l3e2d279fr5b889a4929a9912d@mail.gmail.com>
References: <6217e0a0910300935l3e2d279fr5b889a4929a9912d@mail.gmail.com>
Date: Fri, 30 Oct 2009 14:09:54 -0300
Message-ID: <6217e0a0910301009m71a663efx51e73662653651d1@mail.gmail.com>
Subject: Re: Initialize a runqueue
From: Lucas Prado Melo <lucaspradomelo@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got it: they are initialized on sched_init()

On Fri, Oct 30, 2009 at 1:35 PM, Lucas Prado Melo
<lucaspradomelo@gmail.com> wrote:
> Hello, I would like to know where the runqueue structs are initialized.
>
> Thanks in advance.
>
