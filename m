Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbXJWS10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbXJWS10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 14:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbXJWS1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 14:27:18 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:40779 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbXJWS1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 14:27:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jocRMsN75161NueKRCiZ6HKhI8f/HSayzIs8+zM3bUDMu2P8lQVl3ZTBbZs+dZM3BJj828gWY3LS5scmDggTcwnanFYLekv7WE4FqPdlL6o0KzPsEkOFPf8QyThr20HuKvrfL+P0vlAm99DLPIRFsOLTHPtfKENO6wtr2FKC/dw=
Message-ID: <9e0cf0bf0710231127o485a52e1sc7a06df7c8bc0189@mail.gmail.com>
Date: Tue, 23 Oct 2007 20:27:16 +0200
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Subject: Re: [BUG] rfcomm]
Cc: "Jiri Kosina" <jikos@jikos.cz>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net
In-Reply-To: <1193163905.6184.214.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710231950.31313.alon.barlev@gmail.com>
	 <1193162106.6184.208.camel@violet>
	 <Pine.LNX.4.64.0710232004260.18815@twin.jikos.cz>
	 <1193163905.6184.214.camel@violet>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/07, Marcel Holtmann <marcel@holtmann.org> wrote:
> nice. I've never used it. Currently I am using what comes with Ubuntu
> 7.10 and that seems to work.

Have you tried to suspend while pppd is using rfcomm?

The fact that it happens with suspend2 and uswsusp means that the
issue is suspend blind.
Do you need any more information in order to determine what is the problem?

Best Regards,
Alon Bar-Lev.
