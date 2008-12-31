Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbYLaFap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbYLaFap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 00:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbYLaFag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 00:30:36 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:33798 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbYLaFaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 00:30:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=t8v26TCV3MT6HkMPZ2UDQwtJEkJ1ljfzR4EG7ZkQiTGmc+FRsIpVoX2qkUR8JRBQqS
         0HG0+M8r1e1xlaHm+RgaRwEjG8nUE96FkSi1CedgscFV0xQo1Gfj/R/RYQM/AoPEHjZf
         TEB2FvifoEV4ml1+7DnMEkk8kIkpAzgwP0qz4=
Message-ID: <41d311580812302130y659e1a2p451633d8224200bb@mail.gmail.com>
Date: Wed, 31 Dec 2008 13:30:32 +0800
From: "pl ice" <telent997@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Why kernel make obj file with debug info ?
In-Reply-To: <41d311580812291817w7a9b77b5k8dc46d3657985476@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <41d311580812291817w7a9b77b5k8dc46d3657985476@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ,
       I found kernel use Kbuild to make obj-file,and I objdumped
 these obj file and found they all had section .debug. I think they
 will make building kernel use much more time.why these
 obj file compile to debug version?


 Best Regards
 lin
