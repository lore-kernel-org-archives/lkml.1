Return-Path: <linux-kernel-owner+w=401wt.eu-S965441AbXAXAWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965441AbXAXAWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 19:22:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933157AbXAXAWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 19:22:07 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:5305 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933156AbXAXAWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 19:22:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=KL7kgyuH6CNdOvQoKkpeexozYgY4OMPebmjIMXj+a+8F0IQ6cvV56n+HptwQAxnHfFJvgaGA02BMW7cHfKfAFXEsM7BiyhmgiHp+K6vymw7Lrtw7RldNsvh49xjyxfBxaQx80PQFfPHrlnX3uKHeCkkoOOf7SIgA1tHfcp/bOs0=
Message-ID: <eada2a070701231622w73858129i3319f66fa83a31c1@mail.gmail.com>
Date: Tue, 23 Jan 2007 16:22:02 -0800
From: "Tim Pepper" <lnxninja@us.ibm.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [RFC] pci_bus conversion to struct device
Cc: "Martin Mares" <mj@ucw.cz>, "Matthew Wilcox" <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       benh@kernel.crashing.org
In-Reply-To: <20070118090044.GA23596@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070118005344.GA8391@kroah.com>
	 <20070118022352.GA17531@parisc-linux.org>
	 <mj+md-20070118.081204.18154.nikam@ucw.cz>
	 <20070118090044.GA23596@kroah.com>
X-Google-Sender-Auth: a5b3ad5c446e6e9c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/18/07, Greg KH <greg@kroah.com> wrote:

> Hm, only ia64 enables that option.  Matthew, do you care about those
> files?

Given the ia64 nature, unless benh was truly wanting to do something
or ppc64, IBM's big NUMA boxes are pretty unlikely to care.


Tim
