Return-Path: <linux-kernel-owner+w=401wt.eu-S932541AbZJ3Pzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541AbZJ3Pzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 11:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932502AbZJ3Pzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 11:55:35 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:63104 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473AbZJ3Pze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 11:55:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=owDekbiBOwSiEwkBlT+C5YFts2NYRUgT+fvcwyDneYEqQhof48qaqZA9antT9O5VP7
         v6JJhCFw6nKgM8kq02k7081HjZHRzwm0hWtXtkSX/TvXxDEQhYQftpKh4swvD2LtRr77
         Ey1PGlfXHWTWMBvW94ME9h7EjRkpviT2139xQ=
MIME-Version: 1.0
In-Reply-To: <292693080910300320q1857cc70s73eb524c34af8233@mail.gmail.com>
References: <292693080910290808x69f25f6fgc49cb646c1c00466@mail.gmail.com> 
	<4AE9F3D2.8030502@nortel.com> <292693080910300320q1857cc70s73eb524c34af8233@mail.gmail.com>
From: Mulyadi Santosa <mulyadi.santosa@gmail.com>
Date: Fri, 30 Oct 2009 22:55:19 +0700
Message-ID: <f284c33d0910300855k3ec50ac3pc4cb4053e4341b52@mail.gmail.com>
Subject: Re: Questions about linux scheduler
To: Daniel Rodrick <daniel.rodrick@gmail.com>
Cc: Chris Friesen <cfriesen@nortel.com>,
       Linux Newbie <linux-newbie@vger.kernel.org>,
       Kernel Newbies <kernelnewbies@nl.linux.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 30, 2009 at 5:20 PM, Daniel Rodrick
<daniel.rodrick@gmail.com> wrote:
> One last question ... the nice value of a process never changes
> (unless done explicitly using nice system call), right?
>

Correct.... notice that only root who is able to alter the nice value
of any processes freely. Normal user can only renice its own created
process and only increase its nice value (thus decreasing its static
priority)


-- 
regards,

Mulyadi Santosa
Freelance Linux trainer and consultant

blog: the-hydra.blogspot.com
training: mulyaditraining.blogspot.com
