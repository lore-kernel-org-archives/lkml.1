Return-Path: <linux-kernel-owner+w=401wt.eu-S932821AbYBTXRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821AbYBTXRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 18:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbYBTXRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 18:17:08 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:57646 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbYBTXRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 18:17:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=B60KUX2im7PxZHfyb2+DASZ0hBw34MGV/rrSubjupAT8fJ3Jn/YDwIHa49LoUHS2JGAfzXcIOleWbwkmpJVgn+oJC3J022mfMB1RGCA1BP//1R/NolJB533hZJC1RQwFz4pvWO0qze5frGH1vN5j28fLMXHsHCgtyZrzAacQfmA=
Subject: Re: [PATCH 1/2] moxa: make functions static
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47BCB3EB.1070308@gmail.com>
References: <1203545644.25307.40.camel@brick>  <47BCB3EB.1070308@gmail.com>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 15:17:19 -0800
Message-Id: <1203549439.25307.54.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-21 at 00:12 +0100, Jiri Slaby wrote:
> On 02/20/2008 11:14 PM, Harvey Harrison wrote:
> > All were forward declared static already.
> > 
> Thanks, but I have similar fixes for both issues you address in my tree. I'll 
> post it in few days.

Great.

Harvey

