Return-Path: <linux-kernel-owner+w=401wt.eu-S933344AbXCVPqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933344AbXCVPqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 11:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933388AbXCVPqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 11:46:44 -0400
Received: from dgate2.fujitsu-siemens.com ([217.115.66.36]:11355 "EHLO
	dgate2.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933344AbXCVPqn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 11:46:43 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns; b=VV2QIgu/BGoUi5je2l59D4Yig9TGsF1dZGZYYe3wnFAbUPEcWpa1wgjmj2Af2z2/c1aVO4d/ZPskF5YHZAHCtXM0i1+ZcoOa8UqF8ZsIb6leVlMeqiD33Kywv7JdYsf5;
X-SBRSScore: None
X-IronPort-AV: i="4.14,315,1170630000"; 
   d="scan'208"; a="62803184:sNHT65192552"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: how can I touch softlockup watchdog on all cpus?
Date: Thu, 22 Mar 2007 16:46:31 +0100
Message-ID: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FEB060@ABGEX01E.abg.fsc.net>
in-reply-to: <75b66ecd0703220830wdb4a612u86c80e71d4918cc4@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: how can I touch softlockup watchdog on all cpus?
Thread-Index: AcdslxHU6N7kQw1dQDeS4H4UNCWSPgAAhPTQ
References: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FB6F2A@ABGEX01E.abg.fsc.net> <20070321164404.GF13218@redhat.com> <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FB710B@ABGEX01E.abg.fsc.net> <75b66ecd0703220830wdb4a612u86c80e71d4918cc4@mail.gmail.com>
From: "Cestonaro, Thilo \(external\)" 
	<Thilo.Cestonaro.external@fujitsu-siemens.com>
To: "Lee Revell" <rlrevell@joe-job.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Mar 2007 15:46:34.0622 (UTC) FILETIME=[44F791E0:01C76C99]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Just disable the softlockup watchdog.

Thx for your answer, but this is no option for me, as I said in my first post :(.

Thilo
