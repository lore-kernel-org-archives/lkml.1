Return-Path: <linux-kernel-owner+w=401wt.eu-S1754372Ab0AJXRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab0AJXRL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 18:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301Ab0AJXRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 18:17:09 -0500
Received: from mail-iw0-f194.google.com ([209.85.223.194]:35849 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab0AJXRF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 18:17:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=geueiB6yeqkvkPq0xgBba+xSJDw01Mtn/eMUINUlzNbiYvmT6dEOavHeyMjXw38rf1
         R3y4t6Ba4R+4iY5A0DuOjYclMl/ua1gzj7dx/Jrm3zU6nXm9FkXGZ+Rv7Zz2LyvnA/0v
         g+T6EWyyYG8OvCuRwuiWUzcK/St68PGFkBKc0=
MIME-Version: 1.0
In-Reply-To: <CXIfLt-ygXM.A.-sB.uglSLB@chimera>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
	 <CXIfLt-ygXM.A.-sB.uglSLB@chimera>
Date: Sun, 10 Jan 2010 17:17:04 -0600
Message-ID: <51f3faa71001101517i10bde693n51688e2bd8c411b8@mail.gmail.com>
Subject: Re: [Bug #14922] 2.6.32 seemed to have broken nVidia MCP7A sata 
	controller
From: Robert Hancock <hancockrwd@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Mike Cui <cuicui@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 10, 2010 at 4:56 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14922
> Subject         : 2.6.32 seemed to have broken nVidia MCP7A sata controller
> Submitter       : Mike Cui <cuicui@gmail.com>
> Date            : 2009-12-19 6:13 (23 days old)
> References      : http://marc.info/?l=linux-ide&m=126120323407742&w=4
> Handled-By      : Jeff Garzik <jeff@garzik.org>
>                  Robert Hancock <hancockrwd@gmail.com>

Still outstanding. Waiting for testing results from the reporter with
that drive on another AHCI controller, if possible. I CCed Peer Chen
from NVIDIA on the Bugzilla report, maybe they know if there is some
known problem with FPDMA AA on that controller.
