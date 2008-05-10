Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbYEJUGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbYEJUGz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 16:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbYEJUGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 16:06:45 -0400
Received: from po-out-1718.google.com ([72.14.252.156]:50445 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbYEJUGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 16:06:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C8DcAR0X1WVkM+YGckbfVEL2Y4+4MfJm5J7xjCFZTKMNDw+VpUIBl4HQ2gx/7STxNDVbtHwhKqzjbZ8H/QuDHADgTrtZL50Tj/CvoHOCtZvuCvvLxFLVHS3XRurO6xP9kplJN98mw9aKnA3IavizC9CBuUVAjETVjzpH0pFdDHQ=
Message-ID: <86802c440805101306w64b5c72dn4dbfea74a6557c2f@mail.gmail.com>
Date: Sat, 10 May 2008 13:06:36 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: dougg@torque.net
Subject: Re: lsscsi is broken
Cc: "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Greg KH" <greg@kroah.com>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       Linux-Scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <4825EAA0.5030305@torque.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440805091638q59031edbifa439344acf0c971@mail.gmail.com>
	 <4825EAA0.5030305@torque.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2008 at 11:34 AM, Douglas Gilbert <dougg@torque.net> wrote:
> Which version of lsscsi?
> [For example what is the output of 'lsscsi --version'.]
>
> If it is not version 0.20 beta could you try it.
> See: http://sg.torque.net/scsi/lsscsi.html

it is the one in Opensuse 10.3

YH
