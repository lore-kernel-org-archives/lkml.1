Return-Path: <linux-kernel-owner+w=401wt.eu-S1762386AbYDNVG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762386AbYDNVG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 17:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494AbYDNVGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 17:06:48 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:47599 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbYDNVGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 17:06:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=hrWPrU+dtKDkSmi/V2kUPLnmsEUD02TsomXgZaFQQ3YB0t/tpk5cAPscGVjbAks/F1ob/IQF3pi08GO0iPny/twrcBoDfvGgvLRX9khVzl9vcHXts2SwCnGGoZgyJHhwYg2DBiMHud2vO+1XKNINujQfAp6g7M8ZGydIHYAsbPI=
Message-ID: <84144f020804141406n7ffd8a89ld1008afc1d541640@mail.gmail.com>
Date: Tue, 15 Apr 2008 00:06:46 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [Fwd: [-mm] Add an owner to the mm_struct (v9)]
Cc: "Paul Menage" <menage@google.com>, balbir@linux.vnet.ibm.com,
       serue@us.ibm.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080414123624.0635798d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48036677.3010807@linux.vnet.ibm.com>
	 <48036F14.3050409@cs.helsinki.fi>
	 <6599ad830804140904v66fab79at8c12e19db64f6608@mail.gmail.com>
	 <20080414123624.0635798d.akpm@linux-foundation.org>
X-Google-Sender-Auth: 138183be9ba0dc31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 10:36 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>  > >  Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
>  >
>  > Reviewed-by: Paul Menage <menage@google.com>
>  >
>  > I'm still not sure when to use Acked-by versus Reviewed-by - is it
>  > just based on the level of scrutiny/review?
>
>  Yes.  Reviewed-by: is a lot stronger that Acked-by:.  I've seen some pretty
>  shocking Acked-by:'s :)

Heh, I hope mine wasn't one. But the point here is that, no, I didn't
review the patch that closely (it's mostly cgroup stuff anyway) but I
do want to see struct mm_struct ->owner in the kernel for revoke thus
Acked-by.
