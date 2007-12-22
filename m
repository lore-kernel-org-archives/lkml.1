Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbXLVW5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbXLVW5Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 17:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbXLVW5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 17:57:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:39697 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbXLVW5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 17:57:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eQQgneFbNqN4vtjHJQbwyK81uExe8o6gQgWZXyOBpRfkBxQmEZC1JrVmICUxvhUJdXzDAouBrZzdfyTjOWvyowHEH9Ggy+6oUx3P+alCASUAKYEsAhzO5eTuSqcT/RgphR+gXq8URqWwYgigP2zg1IE/zK5FhqGBn3J/BarWfms=
Message-ID: <f6ca9fed0712221457v78b1672ckd53d3792794d9b94@mail.gmail.com>
Date: Sat, 22 Dec 2007 23:57:12 +0100
From: drago01 <drago01@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: rt2x00 is sapmming my logs
Cc: "=?ISO-8859-1?Q?Alejandro_Riveira_Fern=E1ndez?=" <ariveira@gmail.com>,
       rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200712230004.42957.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071222173153.42f574fd@Varda> <200712230004.42957.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 23, 2007 12:04 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>[..]
> >  The connection seems top work anyways so i do not think this is critical.
> >  Thanks in advance for your time.
>
> I have created a bugzilla entry for this problem at:
> http://bugzilla.kernel.org/show_bug.cgi?id=9622
> and added it to the list of reported regressions.

rt2x00 has been merged in 2.6.24 (did not exist in 2.6.23) so its not
a regression.
