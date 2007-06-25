Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbXFYCbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbXFYCbO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 22:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbXFYCbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 22:31:00 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:46308 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbXFYCa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 22:30:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=SRP7TmxELghJw7sAzPRNQf5anJ8eC2mXBitE1/W75dKZPVg4zo3dg1z6/hrLjsFVKbfeiSvYdJIaIt5zsW/UYQsHAK9F4UrdEDgtoee32Vo2slI8l7En8IJSc8c3RwQzTF8HdyNt2fIwt9GHwC0gGQhIH/sRVXxS31mj4i7eU14=
Message-ID: <467F28DE.8020208@gmail.com>
Date: Mon, 25 Jun 2007 11:30:54 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: enricoss@tiscali.it
CC: linux-kernel@vger.kernel.org
Subject: Re: hsm violation
References: <467E6456.4030503@tiscali.it>
In-Reply-To: <467E6456.4030503@tiscali.it>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Enrico Sardi wrote:
> This is the result of hdparm -I /dev/sda:
> 
> /dev/sda:
> 
> ATA device, with non-removable media
>    Model Number:       Hitachi HTS541616J9SA00

Just in case, you didn't add "Hitachi " in the front of Model Number
string, right?  It looks a bit odd because all other HTS541* drives
don't have leading "Hitachi " in its Model Number.

-- 
tejun
