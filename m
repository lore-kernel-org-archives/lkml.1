Return-Path: <linux-kernel-owner+w=401wt.eu-S1761660AbZEMVkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761660AbZEMVkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 17:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbZEMVke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 17:40:34 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:38108 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438AbZEMVkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 17:40:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Zf39kM5cMJgUK9DliFkCexnDwF5ixS537Re6psE1Zdkh6X1vG/hF4yNA1HcjWNrIox
         IEg716itmyGP19s+r8s7ShF5h+ptopIUjvRjUTc70bcm/GrHinvhTgPf9EBDOhNWCEmD
         4GqscxquErwYArdFzg9LLlkKES2I7+nt8XSgU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/7] ide: minor improvements/cleanups
Date: Wed, 13 May 2009 23:44:48 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-00442-ga3668b0; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20090513205139.28638.87226.sendpatchset@localhost.localdomain>
In-Reply-To: <20090513205139.28638.87226.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905132344.48959.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 May 2009 22:51:39 Bartlomiej Zolnierkiewicz wrote:
> 
> On top of for-next branch of ide-2.6.git tree.

Uh, no.  This is on top of for-next + block (=> linux-next).
