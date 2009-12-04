Return-Path: <linux-kernel-owner+w=401wt.eu-S1753398AbZLDHGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbZLDHGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 02:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbZLDHGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 02:06:33 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:43066 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbZLDHGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 02:06:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=p5V+xdp8InGvrgfEeUjGTfeyXTiAMxtraDYd27bK2AZ88iGZmEBfP3pVwPyfae64vw
         JdGEVNzk+epu47AZzVoRHCx29KfXpCFT1e9Il9SkpBxqRrBoY2zMQ/gVrQjMceRubEL6
         OOYwafcrsvY92cXx53R1TohpHwmonS+GPbMhk=
MIME-Version: 1.0
In-Reply-To: <467878267@web.de>
References: <467878267@web.de>
Date: Fri, 4 Dec 2009 11:06:34 +0400
Message-ID: <1a297b360912032306i57d62509k7e2aeba7916fc63d@mail.gmail.com>
Subject: Re: Is saa716x abandoned?
From: Manu Abraham <abraham.manu@gmail.com>
To: Peter Paul <abnominales@web.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 4, 2009 at 4:33 AM, Peter Paul <abnominales@web.de> wrote:
> Hello,
> I was wondering about the future of the saa716x [1] driver that handles DVB hardware that uses either the saa7160, saa7161, saa1762 or saa1763 chip.
> Has development ceased or was it just moved somewhere else? The driver does not even compile with the latest kernel anymore as of API changes.

I didn't have really much free time the past 2 - 3 months. Development
became slow and still using the same kernel version for development:
2.6.25. The tree had been a minimal tree to have a minimal tree for
ease of handling during the development process (minimal download
time), will be migrating to the standard build this week.

Regards,
Manu
