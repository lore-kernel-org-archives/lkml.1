Return-Path: <linux-kernel-owner+w=401wt.eu-S1760898AbXHGJa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760898AbXHGJa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 05:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757296AbXHGJau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 05:30:50 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:42702 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856AbXHGJas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 05:30:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DucqmnhBrc7NbJG2c3+XFJA2sLOOyqse9XE714oIKcb3GYfPJ37U51d2gT6yM0ViCvtOn+HchqENDzhZCc5yQTUqG0qjCdCsHqQ4GaV+XUwCD009v3sjuB1y6720Sqqo1GXJjTF3SmeIrIIZkjbR1HlhjZjiUGrMFR+vl8qmYsI=
Subject: Re: Disk spin down issue on shut down/suspend to disk
From: Michael Sedkowski <sedmich@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <46B817AB.30105@gmail.com>
References: <838f88840708051428p3d65ff42w627af4bc38f57de3@mail.gmail.com>
	 <1186411815.4355.7.camel@nx6310>
	 <20070806150159.GC31615@khazad-dum.debian.net>
	 <200708061732.03425.rjw@sisk.pl>  <46B75459.9020204@gmail.com>
	 <1186424492.4355.1.camel@nx6310>  <46B76BBC.9010107@gmail.com>
	 <1186438698.4402.6.camel@nx6310>  <46B817AB.30105@gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Tue, 07 Aug 2007 11:30:43 +0200
Message-Id: <1186479043.4664.2.camel@nx6310>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 07-08-2007, Wt o godzinie 15:56 +0900, Tejun Heo napisał(a):
> You can test it by forcefully powering off the
> machine (press power button for several secs or disconnect AC and
> battery) and see whether the count increases. 

Forgot to mention that double spin down does not happen when the laptop
is powered down forcefully and as my friend described who has te same
model it "sounds right"...

