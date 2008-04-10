Return-Path: <linux-kernel-owner+w=401wt.eu-S1754926AbYDJBPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbYDJBPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 21:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbYDJBPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 21:15:00 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:49638 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbYDJBO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 21:14:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=jOWvQTS26dvflkLr9hnjL/+YALojSE388YXsteJwV7bBUpUOdynpmZQ4jGfa9cYWFxhTKFqVVRzKFarxf8AezvneA7cU5JwWLuvVNvo4dvjqG6oWOQdDcvhDr/vLcPzZvA06j8v8Mi6CkwseLM4pp1rvG0nB3vdplgl4fsUzKbk=
Message-ID: <75b66ecd0804091814x659c07f8q68693d1b088e4c21@mail.gmail.com>
Date: Wed, 9 Apr 2008 21:14:57 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Andreas Grimm" <agrimm61@yahoo.com>
Subject: Re:
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <293246.57980.qm@web45116.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <293246.57980.qm@web45116.mail.sp1.yahoo.com>
X-Google-Sender-Auth: 60b865eeb955165d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2008 at 4:45 AM, Andreas Grimm <agrimm61@yahoo.com> wrote:
> Hello everybody,
>
>   i got a weird problem with one of my servers. It's a Intel SR2500AL with 32GB of RAM.
>   Looking at the memory usage of the system, something is going totally wrong. The crucial numbers from /proc/meminfo are:
>
>   MemTotal:     33265916 kB
>   MemFree:        416168 kB
>   Inactive:     24630428 kB   (24GB? whooaaa)
>

Why did you start 3 separate threads for this issue?  That's more
likely to annoy people than to get them to help you.

Lee
