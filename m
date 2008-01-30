Return-Path: <linux-kernel-owner+w=401wt.eu-S1758968AbYA3M3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968AbYA3M3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 07:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbYA3M3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 07:29:13 -0500
Received: from web52003.mail.re2.yahoo.com ([206.190.49.250]:26029 "HELO
	web52003.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751452AbYA3M3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 07:29:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=fr2SsXZW2y3ofWm/wgni94KaJ+Igm4LVPtwzju4uUzEUYvtTPRoZ14S26oXbPrVRp15KPIVFZP8UlJfK8WQfYpnSRL2OtJGI7WTynX1gZvpl6ln0dt9h4OKncp7rBcIdTK5NGC5kEgws6tRB8AL+7JnUe04jPW9Cf7YMmpCZNLI=;
X-YMail-OSG: PBdBWR0VM1koygOK6bdUYhZFiGrehYGympu1m1ZcKEx4LfsFkFfVToyP6gVvcrOIVhD99HIIFpS8ayrUUWWrvwMY6Uq02qx21KPkD1SAxTnO2lbZ6nkCqHEQcJF6zw--
X-Mailer: YahooMailRC/818.31 YahooMailWebService/0.7.162
Date: Wed, 30 Jan 2008 04:29:11 -0800 (PST)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: ARP Bug?
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <754038.30895.qm@web52003.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt:
> If you have the same subnet on multiple interfaces, only the
> first interface will be served.

Does that comply with the standard?




      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ 

