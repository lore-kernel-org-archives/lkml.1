Return-Path: <linux-kernel-owner+w=401wt.eu-S1758563AbZJHNs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563AbZJHNs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 09:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758251AbZJHNsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 09:48:55 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:28386 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758232AbZJHNsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 09:48:55 -0400
From: "Seger, Mark" <mark.seger@hp.com>
To: "util-linux-ng@vger.kernel.org" <util-linux-ng@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 8 Oct 2009 13:46:44 +0000
Subject: Annoucing collectl utilities
Thread-Topic: Annoucing collectl utilities
Thread-Index: AcpIHcX0pzpX4dCHT4yKyGovUCPGaA==
Message-ID: <9FCE3A46FE7C8045A6207AE4B42E9F9A48FBEC3832@GVW1119EXC.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {82D4018D-639F-44CF-A60B-D3E545B6CC95}
x-cr-hashedpuzzle: BABq CcHj CzN0 DcOj EZMd FChh GPFD Hw49 H7GA JE0b LH6y
 LpA9 M5nR R42l S0+l
 VVOP;2;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHUAdABpAGwALQBsAGkAbgB1AHgALQBuAGcAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{82D4018D-639F-44CF-A60B-D3E545B6CC95};bQBhAHIAawAuAHMAZQBnAGUAcgBAAGgAcAAuAGMAbwBtAA==;Thu,
 08 Oct 2009 13:46:44
 GMT;QQBuAG4AbwB1AGMAaQBuAGcAIABjAG8AbABsAGUAYwB0AGwAIAB1AHQAaQBsAGkAdABpAGUAcwA=
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally, a set of utilities to add graphics and some distributed monitoring to collectl.  The most useful is colplot which allows you to generate web- or X-based plots via gnuplot.  You can read more at collect-util.sourceforge.net and if you drill down 1 level you can even see some screen shots.  One particularly interesting screen shot is for colmux, a collectl multiplexor, showing the cpu load on 192 systems (only 1/12 of the 2300 nodes in the cluster) , taking 3 extra-wide monitors to show everything as columns of text once/second where you can clearly see different load patterns.

-mark

