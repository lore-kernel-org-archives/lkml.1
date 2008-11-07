Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbYKGPHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbYKGPHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 10:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbYKGPHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 10:07:38 -0500
Received: from smtp.nokia.com ([192.100.122.230]:38290 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbYKGPHg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 10:07:36 -0500
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" 
	<remi.denis-courmont@nokia.com>
Organization: Maemo Software - Nokia Devices R&D
To: "ext David Newall" <davidn@davidnewall.com>
Subject: Re: time for TCP ECN defaulting to on?
Date: Fri, 7 Nov 2008 17:07:01 +0200
User-Agent: KMail/1.9.10
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dave Hudson <linux-kernel@blueteddy.net>,
       Ilpo =?iso-8859-1?q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Mikael Abrahamsson <swmike@swm.pp.se>,
       David Miller <davem@davemloft.net>, daniel.blueman@gmail.com,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       linux-net@vger.kernel.org
References: <6278d2220811040632u7a36d68ekad5de517fd0671bb@mail.gmail.com> <20081107142950.13906925@lxorguk.ukuu.org.uk> <491454A3.1040802@davidnewall.com>
In-Reply-To: <491454A3.1040802@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200811071707.02030.remi.denis-courmont@nokia.com>
X-OriginalArrivalTime: 07 Nov 2008 15:07:02.0361 (UTC) FILETIME=[7D304490:01C940EA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 November 2008 16:45:55 ext David Newall, you wrote:
> Isn't this a question for the IETF to answer?  Are they saying turn on
> ECN now?

For what it's worth, the IESG says RFC3168 is a PROPOSED STANDARD.
This is the "entry-level maturity for the standards track":
(ftp://ftp.rfc-editor.org/in-notes/bcp/bcp9.txt)

   A Proposed Standard specification is generally stable, has resolved
   known design choices, is believed to be well-understood, has received
   significant community review, and appears to enjoy enough community
   interest to be considered valuable.  However, further experience
   might result in a change or even retraction of the specification
   before it advances.
   (...)
   Implementors should treat Proposed Standards as immature
   specifications.  It is desirable to implement them in order to gain
   experience and to validate, test, and clarify the specification.
   However, since the content of Proposed Standards may be changed if
   problems are found or better solutions are identified, deploying
   implementations of such standards into a disruption-sensitive
   environment is not recommended.

-- 
Rémi Denis-Courmont
Maemo Software, Nokia Devices R&D
