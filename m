Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbZHJK2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbZHJK2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 06:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbZHJK2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 06:28:17 -0400
Received: from smtp-out.google.com ([216.239.33.17]:22911 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbZHJK2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 06:28:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=YzE75tf04pu/M6FeyORX6JvJkT1FfgXU+ApA1gbMhvPHsiNffcKGbPluopUIpb159
	F19Elr8rS95UP6RXwYGDg==
Date: Mon, 10 Aug 2009 03:28:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Kurt Roeckx <kurt@roeckx.be>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13780] NULL pointer dereference loading powernowk8
In-Reply-To: <pRuaDVjxFBG.A.tyE.pD2fKB@chimera>
Message-ID: <alpine.DEB.2.00.0908100323370.17129@chino.kir.corp.google.com>
References: <YCu3FOC0QrC.A.MaE.RD2fKB@chimera> <pRuaDVjxFBG.A.tyE.pD2fKB@chimera>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Aug 2009, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13780
> Subject		: NULL pointer dereference loading powernowk8
> Submitter	: Kurt Roeckx <kurt@roeckx.be>
> Date		: 2009-07-15 18:00 (26 days old)
> 

Kurt, could you post the stack trace and your .config from the 2.6.31-rc5 
try?
