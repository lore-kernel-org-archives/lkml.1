Return-Path: <linux-kernel-owner+w=401wt.eu-S1030891AbXDJPqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030891AbXDJPqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 11:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030892AbXDJPqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 11:46:39 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:5640 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030891AbXDJPqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 11:46:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TEUS1eF3MSjUFKfxlmDW7Yyc2FN6xx5v83HFu9o8r6gebeBolFSvu613Zeq7Hu3zYZAk9vcvufvH5QHuyjDRiVtRNfIzWwiXNa+WIpUlV0nNjlah5w35jFrhoxQvkPvceBQi9w9TOpQDQEi+ItRlKJ/hLUQLeNHoc2+hPtVl7LE=
Message-ID: <4dfa50520704100846s7c031ab0i9da94a9e993cbbfc@mail.gmail.com>
Date: Tue, 10 Apr 2007 08:46:36 -0700
From: "David Hubbard" <david.c.hubbard@gmail.com>
To: "Hans de Goede" <j.w.r.degoede@hhs.nl>
Subject: Re: [lm-sensors] Hardware monitoring subsystem maintainer position is open
Cc: "Jean Delvare" <khali@linux-fr.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "LM Sensors" <lm-sensors@lm-sensors.org>
In-Reply-To: <461BB006.9020308@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070410150227.1bac05b5@hyperion.delvare>
	 <461BB006.9020308@hhs.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On 4/10/07, Hans de Goede <j.w.r.degoede@hhs.nl> wrote:
> Jean Delvare wrote:
> > Hi all,
> >
> > I am resigning from my role as hardware monitoring subsystem
> > (drivers/hwmon) maintainer. This is too much work for me, I do not have
> > the necessary bandwidth to review all the incoming patches, in
> > particular new drivers, in a timely manner. Patch authors have been
> > complaining about this repeatedly. This is no fun for them, and even
> > less for me, so I'd rather let someone else with more spare time take
> > care of it. If there are volunteers, this is the right time to speak up.
>
> But alas, I'm afraid I cannot change your mind, so that brings us to the
> question who will pickup the task. I've considered volunteering myself, but I'm
> to inexperienced when it comes to kernel stuff and lm-sensors for me is kinda a
> side project. I sink most of my spare time into Fedora where I maintain circa
> 120 packages, which really means I have little time left for lm-sensors (to be
> clear the average package maintainer maintains between 30 - 50 packages).

I haven't seen anything from Rudolf Marek, but he is definitely
qualified if he wants to step up. I'm personally hoping Jean changes
his mind.

David
