Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbZDZU6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbZDZU6Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 16:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbZDZU6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 16:58:11 -0400
Received: from mail-qy0-f180.google.com ([209.85.221.180]:50935 "EHLO
	mail-qy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZDZU6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 16:58:10 -0400
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Apr 2009 16:58:09 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aPsEviFSN+5gQ8E76vPyk0fpFa7KkiorL0cWst3mhODlLoch8j1BQLWZeRdRkTgXO0
         /pOg5nxsk6xpQwR2E5D5QX3cN62dpL4Ln3r3rf3h0HQDJOjD1x89kkrGaQR7VNszrB+z
         FX7EhR4jj3cYmnMBu742YlGzOkGGeMODMoBR0=
MIME-Version: 1.0
In-Reply-To: <20090426171640.GA9633@srcf.ucam.org>
References: <alpine.LFD.2.00.0902081251090.3048@localhost.localdomain>
	 <20090209234911.GB862@elte.hu>
	 <5030E21460%linux@youmustbejoking.demon.co.uk>
	 <20090210150431.GA26798@srcf.ucam.org>
	 <5030E7CFF4%linux@youmustbejoking.demon.co.uk>
	 <20090419015614.GA6926@srcf.ucam.org>
	 <71cd59b00904190020x7d946c29w736d89fc27d39594@mail.gmail.com>
	 <20090419151306.GA15048@srcf.ucam.org>
	 <71cd59b00904250712k332bfc14nb181aaabd7c605e5@mail.gmail.com>
	 <20090426171640.GA9633@srcf.ucam.org>
Date: Sun, 26 Apr 2009 22:51:08 +0200
Message-ID: <71cd59b00904261351k18a8bc0cue076c1bb44da4813@mail.gmail.com>
Subject: Re: [PATCH] eee-laptop: Register as a pci-hotplug device
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 26, 2009 at 7:16 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> Hm. I /think/ that version leaks notification handlers on the failure
> path. Does this look ok? I don't have an eee to hand right now, so can't
> test this at the moment.
I'll test it tomorow, but it seems ok.
Thanks

-- 
Corentin Chary
http://xf.iksaif.net
