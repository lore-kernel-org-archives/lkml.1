Return-Path: <linux-kernel-owner+w=401wt.eu-S1764496AbXHHHaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764496AbXHHHaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756588AbXHHHaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:30:01 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:41560 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbXHHH37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:29:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=uCD/YX1PU9usV4BvPyx13DV6xjuOuonnxayPHu++LY3i7OsKwkX2sPP8mnATnDNTi2ip8+FKKGRr2JrH2mIMKcdjcx+7pbh4iBHVgEPPQhQcxrO1O+HKGZ8dLZWukv/SBe+aZ10P203q9yBRwU9xYevR+3DaaKvsypw3ReB/ASg=
Message-ID: <5d6222a80708080029j63af22e9t94cc8dc142c9bc90@mail.gmail.com>
Date: Wed, 8 Aug 2007 04:29:57 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Glauber de Oliveira Costa" <gcosta@redhat.com>
Subject: Re: [PATCH 5/25] [PATCH] native versions for system.h functions
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org
In-Reply-To: <11865467741753-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_19104_9349097.1186558197721"
References: <11865467522495-git-send-email-gcosta@redhat.com>
	 <11865467592921-git-send-email-gcosta@redhat.com>
	 <1186546763582-git-send-email-gcosta@redhat.com>
	 <11865467662182-git-send-email-gcosta@redhat.com>
	 <11865467702103-git-send-email-gcosta@redhat.com>
	 <11865467741753-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_19104_9349097.1186558197721
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Okay, this one is obviously wrong, my fault (it doesn't do what it
says it does in the body of the e-mail. Resending...


-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."

------=_Part_19104_9349097.1186558197721
Content-Type: text/x-patch; 
	name=native-versions-for-system.h-functions.patch; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f53i1q2w
Content-Disposition: attachment; filename="native-versions-for-system.h-functions.patch"

IGFyY2gveDg2XzY0L2tlcm5lbC90Y2UuYyAgICB8ICAgIDIgLQogYXJjaC94ODZfNjQvbW0vcGFn
ZWF0dHIuYyAgIHwgICAgMiAtCiBpbmNsdWRlL2FzbS14ODZfNjQvc3lzdGVtLmggfCAgIDU1ICsr
KysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tCiAzIGZpbGVzIGNoYW5n
ZWQsIDM5IGluc2VydGlvbnMoKyksIDIwIGRlbGV0aW9ucygtKQpmb28K
------=_Part_19104_9349097.1186558197721--
