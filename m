Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbXFUPox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbXFUPox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 11:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbXFUPop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 11:44:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:20377 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbXFUPoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 11:44:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JVchorUPKLN/sicZNPvw5Eo+ocOAkQhfP4uscvY8HjjX7u0GryY5172eh2CL6vG4EeaH6/2u8un3IzUOcyhLgWbA0kEozZCSxweczfjOVsRnPFFoQ4uE+p4wA0GhLQ8H7t8X1BudGm1824vOK+8y6mcCwRPktHFLN16azvY7zNU=
Message-ID: <6bffcb0e0706210844k6f83a0f8n4ee60d98344e7bd8@mail.gmail.com>
Date: Thu, 21 Jun 2007 17:44:43 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: reproducible hang with reiserfs and bash_shared_mapping
Cc: reiserfs-dev@namesys.com, reiserfs-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200706211226.03994.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706211226.03994.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

On 21/06/07, Oliver Neukum <oliver@neukum.org> wrote:
> Hi,
>
> I get reproducible hangs when running bash_shared_mapping from the
> autotest suite. I've tested with a USB mass storage device and a PATA
> hard drive. No difference. Vanilla 2.6.22-rc5 and -git5 are affected. Ext3
> works flawlessly on both devices. Below is the result of sysrq-t while
> tasks are hanging.
>

Is this a regression?

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
