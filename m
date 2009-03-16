Return-Path: <linux-kernel-owner+w=401wt.eu-S1759904AbZCPLCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904AbZCPLCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 07:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbZCPLCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 07:02:42 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:18103 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbZCPLCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 07:02:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=nlNFBixg8nRJ0S2UlOPFscduE3jUuUcjhPbMWCPtXZpUB9yPH/paEEtZW1nW533TdR
         Hni3mRCQRVC0dhheRU/szQl5yTdIdwFloCufUF+NvHO2VfX8YbwZWVKF531urGphRVdK
         n6/oKREa8WFTqIkWv7TRs8/Aj/nXqw83RNURg=
MIME-Version: 1.0
Date: Mon, 16 Mar 2009 11:02:39 +0000
Message-ID: <b6a2d2e20903160402u1086388bx56f3257d11be101@mail.gmail.com>
Subject: RSVP(-TE)
From: Rolando Martins <rolando.martins@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I'm looking for implementations of RSVP (Resource Reservation
Protocol) for Linux or other ways to have  the same QoS reservation
guarantees.
(I have found the mpls-linux project but I'm not sure of it's maturity...)
Does anyone have suggestions?

The tc tool has a filter named RSVP. What does it do exactly?

Thanks,
Rolando
