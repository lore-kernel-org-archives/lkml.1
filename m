Return-Path: <linux-kernel-owner+w=401wt.eu-S964888AbXGQXVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964888AbXGQXVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 19:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936909AbXGQXUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 19:20:16 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:5984 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936882AbXGQXUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 19:20:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JEhhlQmvYl2SKJNxRLzZkUx83raDxf/9FWyFNBEcXiXn4NewV+5joJ9gr2z+RJILFxwdL/7mbL/GA0DW/qL4F6QJ91mt546GiviSNzat5g3NxsN1yPEsLK/jVpakFKguRzlzeaRAhPoepSlonkMqdmp7Ccpqo7MpiWozWaQ/43g=
Message-ID: <21d7e9970707171620k5c3dcab9s7eabbe9f97d26378@mail.gmail.com>
Date: Wed, 18 Jul 2007 09:20:11 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "charles gagalac" <charles.gagalac@gmail.com>
Subject: Re: [BUG] wine locks up system
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org
In-Reply-To: <6cf66ee10707170211t62714949me975656143e7b710@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6cf66ee10707170211t62714949me975656143e7b710@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/07, charles gagalac <charles.gagalac@gmail.com> wrote:
> starting an application under wine 0.9.41 locks up my system.  bisect
> generated the following commit:
>
>  commit d4e2cbe9cb9219fc924191a6baa2369140cb5ea8

Should be fixed now, I missed a patch chunk in that series..

Dave.
