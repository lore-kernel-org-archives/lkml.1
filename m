Return-Path: <linux-kernel-owner+w=401wt.eu-S1761484AbYCALqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761484AbYCALqv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 06:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbYCALqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 06:46:44 -0500
Received: from wx-out-0506.google.com ([66.249.82.228]:64975 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbYCALqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 06:46:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=M7sIRSCz+vC4vKd97YBcCroom+ypKuGRxO1Ek8zSeCfzADSJ/0cy/HgJFLV+mk/7VwRw6Xgv2hz+eJJBa/pEe4GObgc/2nHGXgFtKYXVs/sSEKEqkGFwEKv33yv+yyUNX6iqUMlDYRJ9wQYfdAYOSdnMugB6nuTKp++NOrKsdRY=
Message-ID: <df47b87a0803010346r430520b6h7ccaf408f56c0b60@mail.gmail.com>
Date: Sat, 1 Mar 2008 13:46:40 +0200
From: "Ioan Ionita" <opslynx@gmail.com>
To: "Chris Snook" <csnook@redhat.com>
Subject: Re: Reexport init_mm ?
Cc: drago01 <drago01@gmail.com>, "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <47C84873.4040208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f6ca9fed0802270029l231c6050sefd90ec2997eda37@mail.gmail.com>
	 <47C6617D.1030700@redhat.com>
	 <df47b87a0802290526h322b5cc6va9621e7329d1ac98@mail.gmail.com>
	 <47C84873.4040208@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  High-performance graphics developers are pretty much the last people on
>  earth I want to see writing code that calls init_mm.  These people
>  patent their bugs, rather than fixing them, when they turn out to make
>  things go a little faster and generate "mostly correct" results.  I
>  think we have a lot to teach them about kernel driver development,
>  including how to get by without init_mm being exported.

Interesting how the less knowledgeable seem to be the ones who sign the NDAs
