Return-Path: <linux-kernel-owner+w=401wt.eu-S1751925AbZG3RCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbZG3RCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 13:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbZG3RCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 13:02:34 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:47018 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbZG3RCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 13:02:34 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [RFC] Uni-processor interrupt state preservation.
Date: Thu, 30 Jul 2009 12:01:09 -0500
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200907301137.22035.lkml@morethan.org> <adabpn2rty9.fsf@cisco.com>
In-Reply-To: <adabpn2rty9.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907301201.12197.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu July 30 2009, Roland Dreier wrote:
> 
>  > Just how is the interrupt state (in ebx) supposed to be preserved across
>  > the function call?
> 
> Doesn't the i386 ABI say that ebx is preserved across function calls?
> 
> 

If it does, then that is the answer to my question -
Link to the ABI document please.

Mike
