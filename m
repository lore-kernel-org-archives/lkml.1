Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbYFCSMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbYFCSMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 14:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbYFCSLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 14:11:53 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:23316 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbYFCSLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 14:11:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=akDDAROc+lMGVwrObWAzfW4rXujstL8B/DTlXU4k0zbG5OwBgFhM9STEBQ+mZgAgIvpyjCudHFQ/ITumS9CA0PUIDiCfeGAZiYFZxrfzPRP6BbY6vavE54UAxGo+LSgJSd3sDKkqYz354XLnasYzR0nLdOebT6tMAyUD9dMvaow=
Subject: Re: [PATCH] bluetooth: remove private bitrev16 implementation
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <44F7F2AB-6AC1-457C-A90F-C0927B567F4A@holtmann.org>
References: <1212515734.11008.49.camel@brick>
	 <44F7F2AB-6AC1-457C-A90F-C0927B567F4A@holtmann.org>
Content-Type: text/plain
Date: Tue, 03 Jun 2008 11:11:49 -0700
Message-Id: <1212516709.11008.53.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-03 at 19:59 +0200, Marcel Holtmann wrote:
> Hi Harvey,
> 
> > Expose bitrev16 from lib/bitrev.c and use it.
> 
> can you please split these into two patches. One that exports bitrev16  
> properly and the other one that fixes the Bluetooth driver.
> 

I just sent you a second cleanup patch, I'll split this one and send a
revised 3-patch series including the second cleanup patch.

Harvey

