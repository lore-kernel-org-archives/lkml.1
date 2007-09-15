Return-Path: <linux-kernel-owner+w=401wt.eu-S1760371AbXIOItp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760371AbXIOItp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 04:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbXIOIti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 04:49:38 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:27218 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbXIOIth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 04:49:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TOpsePvpzDIeAxjZ7yYtQjg38TDGxdj8jts23uZsN9vgwEGHsluszDP0psb2IBEgkCy9+8msUZXGpecqzTj7m+9Z6nQVTVmXvHCvgTAAOnf1YCyAFBpu8EIU60Z1d+1tArBVu0v+6mQkT0B95ZCRo7fA3eh/0Gb7vv2cx3sB37I=
Message-ID: <7fac565a0709150149kf55de62q92496cf74e7b0581@mail.gmail.com>
Date: Sat, 15 Sep 2007 11:49:37 +0300
From: "Alexey Eremenko" <al4321@gmail.com>
To: "lkml - Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 2/3] Consolidate host virtualization support under Virtualization menu
In-Reply-To: <1189825504.7262.75.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1189747054.7262.34.camel@localhost.localdomain>
	 <1189747124.7262.36.camel@localhost.localdomain>
	 <20070914091921.73007c5a.randy.dunlap@oracle.com>
	 <1189825504.7262.75.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> We turn "Virtualization" into a menu, not a config option, since it's
> actually only used as a menu.  Then we move lguest under that menu.

What about containerization bits ?

IPC_Namespaces, *_Namespaces  - I think we should evaluate adding them
too to this menu.

-- 
-Alexey Eremenko "Technologov"
