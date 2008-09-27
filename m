Return-Path: <linux-kernel-owner+w=401wt.eu-S1754359AbYI0RaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbYI0RaU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbYI0R3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:29:06 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:10955 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbYI0R3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:29:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=HlfD8WWMz+ZAVxX7dSnAW3gQ5Fsw8vktMmWyjem7O7yd/STAcuCw7ejuDNj7Wypn3+
         N/dzMUNaSxvD4aLg8elDiLUe6/MhEfHtMNEUCgoiqfRIRQkvNl/RJBMQSVomWqR3YZw+
         fFQQKhhN6IU8ev93rblAFgtcoIBrRph1UR8qc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] IDE-TAPE NULL terminate strings.
Date: Sat, 27 Sep 2008 19:04:37 +0200
User-Agent: KMail/1.9.10
Cc: petkovbb@gmail.com, Mark de Wever <koraq@xs4all.nl>,
       Gadi Oxman <gadio@netvision.net.il>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20080921185138.GA16310@localhost> <20080924071055.GB16949@gollum.tnic> <48DA0A39.3070308@ru.mvista.com>
In-Reply-To: <48DA0A39.3070308@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809271904.38023.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 September 2008, Sergei Shtylyov wrote:

[...]

> > Subject: ide-tape: fix vendor strings
> >
> > Remove superfluous two bytes from each string buffer and add proper length
> > format specifiers.
> >
> > There should be no functional change resulting from this patch.
> > 
> > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> > Tested-by: Mark de Wever <koraq@xs4all.nl>
> >   
> 
> Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

applied
