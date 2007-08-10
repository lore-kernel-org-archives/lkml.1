Return-Path: <linux-kernel-owner+w=401wt.eu-S941061AbXHJSrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941061AbXHJSrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 14:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936822AbXHJSr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 14:47:27 -0400
Received: from smtp-out.google.com ([216.239.33.17]:11872 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935664AbXHJSr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 14:47:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=Q6AmHPpNdSWgDoeQFynRHi7pKw7+hp2tr3tDR9ET2I0XoqosHIj3eU10JIgEgs54Q
	BL6ZUZkVUCel7VGkF1zBg==
Subject: Re: [PATCH 2.6.23-rc2] getrusage: return ru_maxrss *WITHDRAWN*
From: Frank Mayhar <fmayhar@google.com>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1186770711.18535.9.camel@peace.smo.corp.google.com>
References: <1186770711.18535.9.camel@peace.smo.corp.google.com>
Content-Type: text/plain
Organization: Google, Inc.
Date: Fri, 10 Aug 2007 11:47:16 -0700
Message-Id: <1186771636.18535.12.camel@peace.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For some reason, the first twenty times I read the doc, I missed the
"terminated and waited-for" bit for RUSAGE_CHILDREN.

Patch withdrawn, for the moment anyway.  (And the right fix won't solve
our problem, sigh.)
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

