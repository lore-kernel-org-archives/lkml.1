Return-Path: <linux-kernel-owner+w=401wt.eu-S1760910AbXIKPo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760910AbXIKPo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 11:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbXIKPou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 11:44:50 -0400
Received: from smtp-out.google.com ([216.239.45.13]:35013 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbXIKPot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 11:44:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=nNJc9QloNGcbN59N8HiDY/SVeA9rQ4wT8/UQGuGdc0RLSdPC6hLGrHruTuRh/m2uZ
	prrBNldD2rDnPSB+qP4Kw==
Message-ID: <6599ad830709110844q143b55fi95a4398261075f9d@mail.gmail.com>
Date: Tue, 11 Sep 2007 08:44:47 -0700
From: "Paul Menage" <menage@google.com>
To: "Cedric Le Goater" <clg@fr.ibm.com>
Subject: Re: [PATCH] Hookup group-scheduler with task container infrastructure
Cc: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>, vatsa@linux.vnet.ibm.com,
       "Andrew Morton" <akpm@linux-foundation.org>,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <46E641C1.8000808@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070910171049.GA16048@linux.vnet.ibm.com>
	 <Pine.LNX.4.64.0709101903220.5368@fbirervta.pbzchgretzou.qr>
	 <20070910172334.GB19100@linux.vnet.ibm.com>
	 <20070910102259.dc45a481.akpm@linux-foundation.org>
	 <20070910174649.GA16222@linux.vnet.ibm.com>
	 <b647ffbd0709101537l9af4dc8x743b25c96e0f5235@mail.gmail.com>
	 <6599ad830709101545s66fd338dob6932407db4e1002@mail.gmail.com>
	 <46E641C1.8000808@fr.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/11/07, Cedric Le Goater <clg@fr.ibm.com> wrote:
> >
> > And "group" is more or less implied by the fact that it's in the
> > containers/control groups filesystem.
>
> "control groups" is the name of your framework. right ?

That's the main contender for the new name, to replace "task
containers" since there were enough objections. (Renamed patches
coming out today, I hope).

Paul
