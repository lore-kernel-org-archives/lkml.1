Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbXJDCx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbXJDCx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 22:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbXJDCxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 22:53:19 -0400
Received: from smtp-out.google.com ([216.239.45.13]:24164 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbXJDCxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 22:53:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=AofofC3UusT64RBNIOU33GT1Nk/iiNtS4Tzkhf7nimUE9liAiTQtwENL+UGFBhx7y
	9DiBAjM/+CP3GczzTgDjw==
Message-ID: <6599ad830710031953o11265ff9kc0dc2bbd6b3b4793@mail.gmail.com>
Date: Wed, 3 Oct 2007 19:53:03 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH 03/33] task containersv11 add tasks file interface
Cc: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, serue@us.ibm.com,
       clg@fr.ibm.com, ebiederm@xmission.com, xemul@openvz.org,
       rientjes@google.com, svaidy@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       a.p.zijlstra@chello.nl, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071003194652.873b0bcf.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070917210307.116234000@menage.corp.google.com>
	 <20070917210426.579524000@menage.corp.google.com>
	 <20071003010923.c606c176.pj@sgi.com>
	 <6599ad830710030816m32321b54gbc79c24d0a39941b@mail.gmail.com>
	 <20071003194652.873b0bcf.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/3/07, Paul Jackson <pj@sgi.com> wrote:
>
> I can't say for sure, but I suspect that if cgroups had always
> been cgroups (short for control groups), then these local 'cont'
> variables would have a different name.

Oh, absolutely. I just refrained from changing them in the rename
since the name was sort of still relevant and it made the change
simpler.

Paul
