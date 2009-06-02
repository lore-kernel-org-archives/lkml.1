Return-Path: <linux-kernel-owner+w=401wt.eu-S1757719AbZFBEmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719AbZFBEmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 00:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZFBEmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 00:42:36 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:45995 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbZFBEmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 00:42:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SKyEKBnulgH/6wgFMNPzGruKD5CdXlllsC5uqr3M8sSpwS6T/ZVUqlvJ3SAMmlVgi/
         Ite2eLRlAjkdKP3OAiP097jrdBq5TVeYaytTJ8mBLxtIX84zQZ70ZA8+gr3LvV+gDuOg
         5fFeNtCL6p/M8klUTbbLWGwehUghNgme1ktMA=
Message-ID: <4A24ADB9.6010903@gmail.com>
Date: Mon, 01 Jun 2009 22:42:33 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andy Isaacson <adi@hexapodia.org>,
       Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
Subject: Re: [Bug #13179] CD-R: wodim intermittent failures
References: <4to6E2myxvG.A.muC.aIbIKB@chimera> <LEcEO2518_I.A.I5E.BKbIKB@chimera>
In-Reply-To: <LEcEO2518_I.A.I5E.BKbIKB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13179
> Subject		: CD-R: wodim intermittent failures
> Submitter	: Andy Isaacson <adi@hexapodia.org>
> Date		: 2009-04-21 1:52 (40 days old)
> References	: http://marc.info/?l=linux-kernel&m=124027879214231&w=4

Last I heard the reporter was going to attempt a bisect, that was a 
while ago. I don't really have any suggestions other than that.
