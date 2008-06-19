Return-Path: <linux-kernel-owner+w=401wt.eu-S1759358AbYFSRDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbYFSRDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 13:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYFSRDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 13:03:35 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:20682 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbYFSRDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 13:03:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=vZbxNwCS2GHFVwMcz6NfEkgcM1q2TFvIkTtPjUSIkANmuIDKIldUOCRfJe3IxI8TMH
         oIaYXVvBUH6sQmqC3dqD2+H9lkqYgLSmOJ6FxuU5EpACEDk0rYUBdgWDL6KdmNY9xbRx
         LLbWM7uuObfzI//9rfa3/5Cxk+vYhhtAiHby8=
Date: Thu, 19 Jun 2008 13:03:09 -0400
From: Josh Boyer <jwboyer@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: lttng git.kernel.org tree
Message-ID: <20080619130309.45cc384b@vader.jdub.homelinux.org>
In-Reply-To: <20080619125157.GA14561@Krystal>
References: <20080619125157.GA14561@Krystal>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2008 08:51:57 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Hi Peter,
> 
> I've been posting my LTTng work through patchsets for a while, but I
> start to think it would be good to deploy a LTTng tree on
> git.kernel.org, do you agree ?

I would like to see that.  I do request that you have per-release
branches/tags with the lttng patches applied though.  Having that via
the patchsets has been quite nice.

josh
